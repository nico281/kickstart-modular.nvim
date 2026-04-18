local M = {}

M.path_sep = vim.fn.has('win32') == 1 and ';' or ':'

function M.prepend_path(paths)
  if type(paths) == 'string' then
    paths = { paths }
  end

  local seen = {}
  local next_parts = {}

  for _, path in ipairs(paths or {}) do
    if path and path ~= '' and not seen[path] then
      seen[path] = true
      table.insert(next_parts, path)
    end
  end

  for _, part in ipairs(vim.split(vim.env.PATH or '', M.path_sep, { plain = true, trimempty = true })) do
    if not seen[part] then
      seen[part] = true
      table.insert(next_parts, part)
    end
  end

  vim.env.PATH = table.concat(next_parts, M.path_sep)
end

function M.find_mise()
  local exepath = vim.fn.exepath 'mise'
  if exepath ~= '' then
    return exepath
  end

  local candidates = {
    vim.fs.joinpath(vim.fn.expand '~', '.local', 'bin', 'mise'),
    '/opt/homebrew/bin/mise',
    '/usr/local/bin/mise',
  }

  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
end

function M.mise(args)
  local mise = M.find_mise()
  if not mise then
    return nil, 'mise not found'
  end

  local result = vim.system(vim.list_extend({ mise }, args), { text = true }):wait()
  if result.code ~= 0 then
    return nil, vim.trim(result.stderr or result.stdout or '')
  end

  return vim.trim(result.stdout)
end

function M.mise_which(name)
  local path = M.mise { 'which', name }
  if path and vim.fn.executable(path) == 1 then
    return path
  end
end

function M.mise_where(name)
  return M.mise { 'where', name }
end

return M
