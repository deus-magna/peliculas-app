import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class MovieDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10.0,
              ),
            _posterTitle(context, pelicula),
            _description(pelicula),
            _description(pelicula),
            _aditionalInfo(pelicula),
            _casting(pelicula),
          ]),
        )
      ],
    ));
  }

  Widget _createAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.black,
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitle(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title,
                    style: TextStyle( color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle,
                    style: TextStyle( color: Colors.white, fontSize: 14.0),
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border, color: Colors.yellow,),
                    SizedBox(width: 5.0,),
                    Text(pelicula.voteAverage.toString(),
                        style: TextStyle( color: Colors.white, fontSize: 14.0),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
                SizedBox(height: 5.0,),
                Row(
                  children: <Widget>[
                    Icon(Icons.thumb_up, color: Colors.white,),
                    SizedBox(width: 5.0,),
                    Text(pelicula.voteCount.toString(),
                        style: TextStyle( color: Colors.white, fontSize: 14.0),
                        overflow: TextOverflow.ellipsis),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
        style: TextStyle( color: Colors.white, fontSize: 14.0)
      ),
    );
  }

  Widget _casting(Pelicula pelicula) {
    final movieProvider = new PeliculasProvider();

    return FutureBuilder(
      future: movieProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
        if (snapshot.hasData) {
          return _createActorsPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createActorsPageView(List<Actor> actors) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        itemCount: actors.length,
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemBuilder: (context, index) {
          return _actorCard(actors[index]);
        },
      ),
    );
  }

  Widget _actorCard(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getPhoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox( height: 8.0,),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle( color: Colors.white, fontSize: 12.0)
          )
        ],
      ),
    );
  }

  Widget _aditionalInfo(Pelicula pelicula) {

    String adultsOnly = 'Pelicula para todo publico';
    if (pelicula.adult) {
      adultsOnly = 'Pelicula solo para adultos';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'Fecha de estreno: ${pelicula.releaseDate}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle( color: Colors.white, fontSize: 14.0),
              textAlign: TextAlign.start,
            ),
            Text(
              'Lenguaje original: ${pelicula.originalLanguage}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle( color: Colors.white, fontSize: 14.0),
              textAlign: TextAlign.start,
            ),
            Text(
              adultsOnly,
              overflow: TextOverflow.ellipsis,
              style: TextStyle( color: Colors.white, fontSize: 14.0),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
