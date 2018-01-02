-- Clean docx xml tag using libre office
-- Author: Jeffry L <paragasu@gmail.com>

local lfs = require 'lfs'
local exec = require 'resty.exec'
local sock_file = '/home/rogon/tmp/exec.sock' 

-- get full filename of the cleaned docx file 
-- @param string original docx template file
-- @return string cleaned xml filename
function m:get_cleaned_docx_file(docx_file)
  local tmp_doc = self.tmp_dir .. '/'.. m.get_filename(docx_file)
  if m.file_exists(docx_file) and not m.file_exists(tmp_doc) then 
    ngx.log(ngx.ERR, "Generate a clean docx template" .. docx_file)
    m.clean_docx_xml(self, docx_file) 
  end
  return tmp_doc
end

-- clean docx xml using libreoffice
-- /usr/bin/libreoffice --headless --convert-to docx --outdir ~/tmp docx_file
function m:clean_docx_xml(input_docx)
  if not self.tmp_dir then error("tmp_dir is missing " .. i(self.tmp_dir)) end
  if not input_docx then error("Missing input file " .. i(input_docx)) end
  local prog = exec.new(sock_file)
  local cmd  = string.format('/usr/bin/libreoffice --headless --convert-to docx:"MS Word 2007 XML" --outdir %s %q', self.tmp_dir, input_docx)
  --prog.stdin = string.format('--headless --convert-to docx:"MS Word 2007 XML" --outdir %s %q', self.tmp_dir, input_docx)
  local res, err = prog('/bin/bash', '-c', cmd);
  --ngx.log(ngx.ERR, "cmd result", cmd, i(res), i(err)) 
  if res and string.find(res.stdout, "using filter") then 
    --m.set_file_writeable(self.tmp_dir .. '/' .. m.get_filename(docx_file))
    return true 
  else
    error("Failed to generate a clean docx file: " .. cmd .. i(res))  
  end
end
