import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapas_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    context.read<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    final miUbicacionBloc = BlocProvider.of<MiUbicacionBloc>(context);

    return Scaffold(
      body: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
        builder: (_, state) {
          return crearMapa(state);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        FloatingActionButton(
          heroTag: 'seguir',
          onPressed: () {
            final destino = miUbicacionBloc.state.ubicacion;
            mapaBloc.moverCamara(destino);
           },
          elevation: 0,
          splashColor: Colors.transparent,
          highlightElevation: 0,
          backgroundColor: Colors.black38,
          child: Icon(Icons.my_location),
        ),

        SizedBox(height: 5),
        
        FloatingActionButton(
          heroTag: 'linea',
          onPressed: () {
            mapaBloc.add(OnMarcarRecorrido());
           },
          elevation: 0,
          splashColor: Colors.transparent,
          highlightElevation: 0,
          backgroundColor: Colors.black38,
          child: Icon(Icons.more_horiz),
        ),

        SizedBox(height: 5),

        FloatingActionButton(
          heroTag: 'seguirauto',
          onPressed: () {
            mapaBloc.add(OnSeguirUbicacion());
           },
          elevation: 0,
          splashColor: Colors.transparent,
          highlightElevation: 0,
          backgroundColor: Colors.black38,
          child: _iconSeguir(mapaBloc.state),
        ),
      ]),
    );
  }

  Widget _iconSeguir(MapaState state){
    return BlocBuilder <MapaBloc, MapaState>(builder: (context,state){
      return Icon( state.seguirUbicacion ? Icons.directions_run :Icons.accessibility );
    });
  }

  Widget crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion) {
      return Text('Ubicando...');
    }

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add(OnLocationUpdate(state.ubicacion));

    final camaraPosition =
        new CameraPosition(target: state.ubicacion, zoom: 15);

    return GoogleMap(
        initialCameraPosition: camaraPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (controller) => mapaBloc.initMapa(controller),
        polylines: mapaBloc.state.polylines.values.toSet(),
        onCameraMove: (cameraPosition){
          // cameraPosition.target = LatLng(mapaBloc.ubicacionCentral);
          mapaBloc.add(OnMovioMapa(cameraPosition.target));
        },
    );
        
  }
}
