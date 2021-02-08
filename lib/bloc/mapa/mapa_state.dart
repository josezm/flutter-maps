part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;
  final LatLng ubicacionCentral;

  final Map<String, Polyline> polylines;

  MapaState({this.ubicacionCentral, this.dibujarRecorrido = true, this.mapaListo = false, polylines, this.seguirUbicacion = false})
      : this.polylines = polylines ?? new Map();

  MapaState copyWith({LatLng ubicacionCentral, bool mapaListo, bool dibujarRecorrido, Map<String, Polyline> polylines, bool seguirUbicacion}) =>
      MapaState(
        mapaListo: mapaListo ?? this.mapaListo,
        polylines: polylines ?? this.polylines,
        dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
        seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
        ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
      );
}
