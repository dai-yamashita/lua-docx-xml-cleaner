-- Unit test
-- Author: Jeffry L <paragasu@gmail.com>

local docx = require 'docxcleaner'
local lfs  = require 'lfs'
local doc  = docx.new('./test/tmp', '/home/rogon/tmp/exec.sock')

require 'busted.runner'()

describe('Docx', function()
  it('get_filename', function()
    local name = docx.get_filename('./test/doc test.docx') 
    assert.are.equal(name, 'doc test.docx')
  end) 

  it('file_exists', function()
    local file = docx.file_exists('/tmp/no-exists')
    assert.are.equal(file, false)
  end)

  it('file_exists', function()
    local file = docx.file_exists(nil)
    assert.are.equal(file, false)
  end)

  it('file_exists', function()
    local file = docx.file_exists(lfs.currentdir() .. '/test/doc test.docx')
    assert.are.equal(file, true)
  end)

  it('./test/tmp is public writeable', function()
    local dir = docx.file_writeable(lfs.currentdir() .. '/test/tmp')
    assert.are.equal(dir, true)
  end)

  it('Output docx using libreoffice', function()
    local res = doc:clean_xml(lfs.currentdir() .. '/test/testdoc.docx') 
    assert.are.equal(res, true)
  end) 

end)
