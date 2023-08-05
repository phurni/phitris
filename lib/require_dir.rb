# helper that requires all ruby file in a directory
def require_dir(dirpath, options = {})
  Array(options[:first]).each {|name| require normalize_game_path(dirpath, name) }
  list_files(dirpath).each {|name| require normalize_game_path(dirpath, name) }
end

# DragonRuby specific helper functions used by `require_dir`
def list_files(dir)
  $gtk.list_files(normalize_game_path(dir))
end

def normalize_game_path(*paths)
  # remove any '.', './something' or 'something/.'. Warning: DOES NOT process '..'
  paths.map {|path| path.split('/').reject {|item| item == '.'}.join('/') }.join('/')
end
