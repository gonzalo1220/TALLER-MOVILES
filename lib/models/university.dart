class University {
  final String id;
  final String nit;
  final String nombre;
  final String direccion;
  final String telefono;
  final String paginaWeb;

  University({
    required this.id,
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.paginaWeb,
  });

  factory University.fromMap(String id, Map<String, dynamic> map) {
    return University(
      id: id,
      nit: map['nit']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      direccion: map['direccion']?.toString() ?? '',
      telefono: map['telefono']?.toString() ?? '',
      paginaWeb: map['pagina_web']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nit': nit,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'pagina_web': paginaWeb,
    };
  }
}
