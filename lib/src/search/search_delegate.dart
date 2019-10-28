import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  final peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Los iconos a la izquierda del appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    ); 
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }
    
    return FutureBuilder(
      future: peliculasProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if(snapshot.hasData){

           final peliculas = snapshot.data; 

           return ListView(
             children: peliculas.map( (pelicula) {
               return ListTile(
                 leading: FadeInImage(
                   image: NetworkImage(pelicula.getPosterImg()),
                   placeholder: AssetImage('assets/img/no-image.jpg'),
                   width: 50.0,
                   fit: BoxFit.contain,
                 ),
                 title: Text( pelicula.title),
                 subtitle: Text(pelicula.originalTitle),
                 onTap: () {
                   close(context, null);
                   pelicula.uniqueId = '';
                   Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                 },
               );
             }).toList()
           );
        } else {
          return Center( child: CircularProgressIndicator());
        }
      },
    );
  }

}