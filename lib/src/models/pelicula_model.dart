class Peliculas {

  List<Pelicula> items = new List();

  Peliculas();

  Peliculas.fromJsonList( List<dynamic> jsonList) {
    if (jsonList == null)  return;
    
    for (var item in jsonList) {
      final pelicula = new Pelicula.fromJsonMap(item);
      items.add( pelicula );
    }
  }

}


class Pelicula {

  String uniqueId;

  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  Pelicula({
    this.voteCount,
    this.popularity,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  Pelicula.fromJsonMap( Map<String, dynamic> json) {    
    
    voteCount = json['vote_count'];
    popularity = json['popularity'] / 1;
    video = json['video'];
    posterPath = json['poster_path'];
    id = json['id'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    title = json['title'];
    voteAverage = json['vote_average'] / 1;
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  getPosterImg(){

    if ( posterPath == null ) {
      return 'http://www.independentmediators.co.uk/wp-content/uploads/2016/02/placeholder-image.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';    
    }
  }

  getBackgroundImg(){

    if ( backdropPath == null ) {
      return 'http://www.independentmediators.co.uk/wp-content/uploads/2016/02/placeholder-image.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';    
    }
  }
}
