-- PDF deliverables: unwrap intra-repo links (relative .md paths, local paths).
-- Keeps link label text; removes hrefs that do not work in client-facing PDFs.

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
  -- Other relative repo paths (runbooks/, infra/, modules/, etc.)
  if not path:match("^/") and path:match("/") then
    return true
  end
  return false
end

function Link(el)
  if is_local_doc_link(el.target) then
    return el.content
  end
  return nil
end
