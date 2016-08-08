#! /usr/bin/env python2
import os
import re
import imdb
import pickle
# TODO: use logger

ia = imdb.IMDb()
# TODO: expand ~/
cache_dir = "/home/ali/.imdbpy/cache"
movies_path = '/run/media/ali/Tuxitop2TB/Videos/Movies/'
casts_path = '/run/media/ali/Tuxitop2TB/Videos/MoviesSorted/Cast/'
directors_path = '/run/media/ali/Tuxitop2TB/Videos/MoviesSorted/Director/'
genres_path = '/run/media/ali/Tuxitop2TB/Videos/MoviesSorted/Genre/'

if not os.path.exists(cache_dir):
    os.makedirs(cache_dir)
if not os.path.exists(movies_path):
    os.makedirs(movies_path)
if not os.path.exists(casts_path):
    os.makedirs(casts_path)
if not os.path.exists(directors_path):
    os.makedirs(directors_path)
if not os.path.exists(genres_path):
    os.makedirs(genres_path)

# TODO: list only files, not symlinks, better to
#       set criteria for ext (RECURSIVELY).
movies = os.listdir(movies_path)
movies_length = len(movies)
for idx, filename in enumerate(movies):
    idx += 1
    filepath = os.path.join(movies_path, filename)
    matched = re.match("(\d{4}) - (.*) \[.*\]", filename)
    if matched:
        if os.path.exists(os.path.join(cache_dir, '%s.cache' % filename)):
            print('[%s/%s] Load from cache: %s' % (idx, movies_length,
                  filename))
            with open(os.path.join(cache_dir,
                      '%s.cache' % filename), 'r') as f:
                movie_pickled = f.read()
            movie = pickle.loads(movie_pickled)
        else:
            year, title = matched.groups()
            year = int(year)
            print('[%s/%s] Searching %s' % (idx, movies_length, filename))
            for try_count in range(3):
                if try_count > 0:
                    print ("Trying again")
                try:
                    s_result = ia.search_movie(title)
                    break
                except:
                    s_result = []
                    print("Error contacting the imdb sever.")


            movie = None
            for item in s_result:
                if item.data.get('year'):
                    if item.data['year'] == year:
                        print('Found a match. getting the movie info')
                        movie = item
                        for try_count in range(3):
                            if try_count > 0:
                                print ("Trying again")
                            try:
                                ia.update(movie)
                                break
                            except:
                                movie = None;
                                print("Error contacting the imdb sever.")
                        break

        if movie:
            # RECORD CACHE
            movie_pickled = pickle.dumps(movie)
            with open(os.path.join(cache_dir,
                      '%s.cache' % filename), 'w') as f:
                f.write(movie_pickled)

            # movie['full-size cover url'], 'rating', 'genres'
            for cast in movie.data['cast'][0:3]:
                cast_name = cast['name']
                print("Found cast: " + cast_name)
                cast_path = os.path.join(casts_path, cast_name)
                if not os.path.exists(cast_path):
                    os.mkdir(cast_path)
                symlink = os.path.join(cast_path, filename.decode('utf-8'))
                # Get relative paths (in case of external media)
                filepath_rel = os.path.relpath(filepath, cast_path)
                if not os.path.exists(symlink):
                    os.symlink(filepath_rel, symlink)

            for director in movie.data['director']:
                director_name = director['name']
                print("Found director: " + director_name)
                director_path = os.path.join(directors_path, director_name)
                if not os.path.exists(director_path):
                    os.mkdir(director_path)
                symlink = os.path.join(director_path, filename.decode('utf-8'))
                # Get relative paths (in case of external media)
                filepath_rel = os.path.relpath(filepath, cast_path)
                if not os.path.exists(symlink):
                    os.symlink(filepath_rel, symlink)

            for genre_name in movie.data.get('genres', []):
                print("Found genre: " + genre_name)
                genre_path = os.path.join(genres_path, genre_name)
                if not os.path.exists(genre_path):
                    os.mkdir(genre_path)
                if not os.path.exists(genre_path):
                    os.mkdir(genre_path)
                symlink = os.path.join(genre_path, filename.decode('utf-8'))
                # Get relative paths (in case of external media)
                filepath_rel = os.path.relpath(filepath, cast_path)
                if not os.path.exists(symlink):
                    os.symlink(filepath_rel, symlink)
        else:
            print('\tMovie Not Found')
