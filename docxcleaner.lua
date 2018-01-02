-- Clean docx xml tag using libre office
-- Author: Jeffry L <paragasu@gmail.com>

local lfs = require 'lfs'
local exec = require 'resty.exec'

local m = {}
m.__index = m

function m.new(tmp_dir, sock_file_path)
  local tmp_doc = self.tmp_dir .. '/'.. m.get_filename(docx_file)
  if m.file_exists(docx_file) and not m.file_exists(tmp_doc) then 
    ngx.log(ngx.ERR, "Generate a clean docx template" .. docx_file)
  end

  local self = setmetatable({}, m)
  self.tmp_doc = tmp_doc
  return self
end


-- clean docx xml using libreoffice
-- /usr/bin/libreoffice --headless --convert-to docx --outdir ~/tmp docx_file
function m.clean_xml(self, input_docx)

  if not self.tmp_dir then error("tmp_dir is missing " .. i(self.tmp_dir)) end
  if not input_docx then error("Missing input file " .. i(input_docx)) end

  local prog = exec.new(sock_file)
  local cmd  = string.format('/usr/bin/libreoffice --headless --convert-to docx:"MS Word 2007 XML" --outdir %s %q', self.tmp_dir, input_docx)
  local res, err = prog('/bin/bash', '-c', cmd);
  if res and string.find(res.stdout, "using filter") then 
    return true 
  else
    error("Failed to generate a clean docx file: " .. cmd .. i(res))  
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

return m
