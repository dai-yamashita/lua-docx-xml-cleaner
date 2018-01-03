-- Clean docx xml tag using libre office
-- Author: Jeffry L <paragasu@gmail.com>

local lfs = require 'lfs'
local exec = require 'resty.exec'
local i = require 'inspect'

local m = {}
m.__index = m

function m.new(tmp_dir, sock_file_path)
  local self = setmetatable({}, m)
  self.tmp_dir = tmp_dir
  self.sock_file = sock_file_path
  if not self.tmp_dir then error("tmp_dir is missing " .. i(self.tmp_dir)) end
  if not sock_file_path then error("Missing required sock file path") end
  if not m.file_writeable(tmp_dir) then error(self.tmp_dir .. " not writeable") end
  return self
end


-- clean docx xml using libreoffice
-- /usr/bin/libreoffice --headless --convert-to docx --outdir ~/tmp docx_file
function m.clean_xml(self, input_docx)
  if not input_docx then error("Missing input file " .. i(input_docx)) end

  local prog = exec.new(self.sock_file)
  if not prog then error(err) end

  prog.argv = {
    '/usr/bin/libreoffice',
    '--headless',
    '--convert-to',
    'docx:"MS Word 2007 XML"',
    '--outdir',
    self.tmp_dir,
    input_docx
  }

  --local cmd  = string.format('/usr/bin/libreoffice --headless --convert-to docx:"MS Word 2007 XML" --outdir %s %q', self.tmp_dir, input_docx)
  --local res, err = prog('/bin/bash', '', cmd);
  local res, err = prog()
  ngx.log(ngx.ERR, err, i(res) .. " " ..  input_docx)
  if res and string.find(res.stderr, "Error") or res.exitcode > 0  then 
    error("Failed to generate a clean docx file: " ..  i(res.stderr))  
  else
    return true 
  end
end

-- get the filename given full path
-- @param string path
-- @return string filename
function m.get_filename(path)
  if type(path) ~= 'string' then error('Invalid filename') end
  return string.match(path, '[%w%d%s%-%._]+%.docx')
end

-- check if file exists
-- @param string full path to filename
-- @return boolean
function m.file_exists(filename)
  if type(filename)~="string" then return false end
  if not lfs.attributes(filename) then return false end
  return true
end

-- make file writeable
function m.file_set_writeable(file)
  return os.execute('chmod +w "' .. file .. '"')
end

-- check if directory/file writeable
function m.file_writeable(file)
  if not m.file_exists(file) then return false end
  local stat = lfs.attributes(file)
  if not stat then error(file .. "do not exists") end
  local perm = string.sub(stat.permissions, 8, 8)
  return perm == 'w'
end

return m
