part of restfulplus.formats;

abstract class Format {

  final String contentType;

  Format(this.contentType);

  Object deserialize(String response);
  String serialize(Object data);
}
