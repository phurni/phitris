# helper that requires all ruby file in a directory
def require_dir(dirpath, options = {})
  Array(options[:first]).each {|name| require normalize_game_path(dirpath, name) }
  list_files(dirpath).each {|name| require normalize_game_path(dirpath, name) }
end

# DragonRuby specific helper functions used by `require_dir`
def list_files(dir)
  $gtk.exec("ls #{dir}").split("\n")
end

ABSOLUTE_GAME_PATH = File.expand_path($gtk.get_game_dir)
def normalize_game_path(*paths)
  absolute_path = File.expand_path(File.join(*paths))
  absolute_path.delete_prefix(ABSOLUTE_GAME_PATH)
end
