# Load MySQL::Result monkeypatch when using mysql database.

begin
  require './lib/mysql_utf8'
rescue LoadError
end
