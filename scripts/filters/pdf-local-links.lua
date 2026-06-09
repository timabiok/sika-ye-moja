-- PDF deliverables: remove all intra-repo markdown document references.
-- Strips local .md links, paths, and filename mentions; keeps external https:// links.

local md_path = "[%w%.%-_/]+%.md#?[%w%-_]*"

local function is_local_doc_link(target)
  if not target or target == "" then
    return false
  end
  if target:match("^https?://") or target:match("^mailto:") then
    return false
  end
  if target:match("^#") then
    return false
  end
  local path = target:match("^([^#]+)")
  if path:match("%.md$") or path:match("%.md/") then
    return true
  end
  if not path:match("^/") and path:match("/") then
    return true
  end
  return false
end

local function link_mentions_md(el)
  local text = pandoc.utils.stringify(el.content)
  return text:match("%.md") ~= nil
end

local function strip_md_references(text)
  if not text or text == "" then
    return ""
  end

  -- Parenthetical doc refs: (FOO.md) or (via CHARTER-ADDENDUM.md)
  text = text:gsub("%s*%(%s*" .. md_path .. "[^%)]*%s*%)", "")
  text = text:gsub("%s*%(%s*" .. md_path .. "%s*%)", "")

  -- Clause / list separators with doc names
  text = text:gsub("%s*[—–-]%s*" .. md_path, "")
  text = text:gsub("%s*;%s*" .. md_path, "")
  text = text:gsub("%s*·%s*" .. md_path, "")

  -- Trailing or inline bare doc paths and filenames
  text = text:gsub("%s*" .. md_path, "")
  text = text:gsub(md_path, "")

  -- Phrases left awkward after removal
  text = text:gsub("See%s+for%s+", "For ")
  text = text:gsub("See%s*,%s*", "")
  text = text:gsub("Track in%s*%.", "Track deliverables.")
  text = text:gsub("Master mapping:%s*", "Master mapping. ")
  text = text:gsub("Master scope:%s*$", "")
  text = text:gsub("Original contract:%s*$", "")
  text = text:gsub("Full classification:%s*", "Full classification. ")
  text = text:gsub("Full advisory:%s*$", "")
  text = text:gsub("Gap output:%s*", "Gap output. ")
  text = text:gsub("Runbook:%s*$", "")
  text = text:gsub("Bridge:%s*$", "")
  text = text:gsub("Ingress options and sign-off:%s*", "Ingress options and sign-off. ")
  text = text:gsub("Industry benchmarks from%s*%.", "Industry benchmarks apply.")

  -- Punctuation and spacing cleanup
  text = text:gsub("%(%s*%)", "")
  text = text:gsub("%s+·%s+", " · ")
  text = text:gsub("^%s*·%s*", "")
  text = text:gsub("%s*·%s*$", "")
  text = text:gsub("%s+,%s*,", ",")
  text = text:gsub(":%s*:", ":")
  text = text:gsub("%s+", " ")
  text = text:gsub("^%s+", "")
  text = text:gsub("%s+$", "")

  return text
end

local function clean_inlines(inlines)
  local cleaned = pandoc.List()
  local last_was_space = false

  for _, inline in ipairs(inlines) do
    if inline.t == "Str" then
      local text = strip_md_references(inline.text)
      if text ~= "" then
        cleaned:insert(pandoc.Str(text))
        last_was_space = false
      end
    elseif inline.t == "Space" then
      if #cleaned > 0 and not last_was_space and cleaned[#cleaned].t ~= "Space" then
        cleaned:insert(inline)
        last_was_space = true
      end
    elseif inline.t == "Code" then
      if not inline.text:match("%.md") then
        cleaned:insert(inline)
        last_was_space = false
      end
    elseif inline.t == "Link" then
      if not is_local_doc_link(inline.target) and not link_mentions_md(inline) then
        cleaned:insert(inline)
        last_was_space = false
      end
    else
      cleaned:insert(inline)
      last_was_space = false
    end
  end

  return cleaned
end

local function inlines_empty(inlines)
  if #inlines == 0 then
    return true
  end
  local text = pandoc.utils.stringify(inlines)
  text = text:gsub("%s+", "")
  return text == ""
end

function Link(el)
  if is_local_doc_link(el.target) or link_mentions_md(el) then
    return {}
  end
  return nil
end

function Code(el)
  if el.text:match("%.md") then
    return {}
  end
  return nil
end

function Str(el)
  local text = strip_md_references(el.text)
  if text == "" then
    return {}
  end
  if text ~= el.text then
    return pandoc.Str(text)
  end
  return nil
end

function Para(el)
  local content = clean_inlines(el.content)
  if inlines_empty(content) then
    return {}
  end
  el.content = content
  return el
end

function Plain(el)
  local content = clean_inlines(el.content)
  if inlines_empty(content) then
    return {}
  end
  el.content = content
  return el
end

function Header(el)
  el.content = clean_inlines(el.content)
  return el
end

function BlockQuote(el)
  local blocks = pandoc.List()
  for _, block in ipairs(el.content) do
    if block.t ~= "Para" or not inlines_empty(clean_inlines(block.content)) then
      blocks:insert(block)
    end
  end
  if #blocks == 0 then
    return {}
  end
  el.content = blocks
  return el
end
