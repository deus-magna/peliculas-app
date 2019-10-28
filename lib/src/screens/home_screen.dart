import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';

import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal_widget.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class HomeScreen extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Películas en cines', 
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context, 
                delegate: DataSearch()
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _auth.signOut();
              //Navigator.of(context).pushReplacementNamed('login');
              Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_swiperTarjetas(), _footer(context)],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      //initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Peliculas populares',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 8.0,),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal( 
                  peliculas: snapshot.data,
                  nextPage: peliculasProvider.getPopulares,
                  );
              } else {
               return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
