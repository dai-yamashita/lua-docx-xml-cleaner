package = "lua-docx-xml-cleaner"
version = "0.1-0"
source = {
   url = "git://github.com/paragasu/lua-docx-xml-cleaner.git",
   tag = "v0.1-0"
}
description = {
   summary  = "Clean docx xml using libreoffice",
   homepage = "https://github.com/paragasu/lua-docx-xml-cleaner",
   license  = "MIT",
   maintainer = "Jeffry L. <paragasu@gmail.com>"
}
dependencies = {
   "lua >= 5.1",
   "lua-resty-exec",
}
build = {
   type = "builtin",
   modules = {
      ["docx-cleaner"] = "docxcleaner.lua"
   }
}
