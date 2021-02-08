import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapas_app/themes/uber_map.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

  GoogleMapController _mapController;

  Polyline _miRuta = new Polyline(
    polylineId: PolylineId('mi_ruta'),
    width: 4,
    color: Colors.transparent,
  );

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      this._mapController = controller;
    }

    this._mapController.setMapStyle(jsonEncode(uberMapStyle));

    add(OnMapaListo());
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }


  @override
  Stream<MapaState> mapEventToState(
    MapaEvent event,
  ) async* {
    if (event is OnMapaListo) {
      print('Mapa listo');
      yield state.copyWith(mapaListo: true);
    }
    
    else if (event is OnLocationUpdate) {

      if(state.seguirUbicacion){
        this.moverCamara(event.ubicacion);
      }

      List<LatLng> points = [...this._miRuta.points, event.ubicacion];
      this._miRuta = this._miRuta.copyWith(pointsParam: points);
      final currentPolylines = state.polylines;
      currentPolylines['mi_ruta'] = this._miRuta;
      yield state.copyWith(polylines: currentPolylines);
    }
    
    else if (event is OnMarcarRecorrido) {
      if (!state.dibujarRecorrido) {
        this._miRuta = this._miRuta.copyWith(colorParam: Colors.black87);
      }
      else {
        this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);
      }

      final currentPolylines = state.polylines;
      currentPolylines['mi_ruta'] = this._miRuta;
      yield state.copyWith(
          dibujarRecorrido: !state.dibujarRecorrido,
          polylines: currentPolylines);
    }

    else if(event is OnSeguirUbicacion){
      if(!state.seguirUbicacion){
        this.moverCamara(this._miRuta.points[this._miRuta.points.length-1]);
      }
      yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
    }

    else if(event is OnMovioMapa){
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    }

  }
}
