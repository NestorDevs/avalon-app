import 'dart:ui';

class ScreenUtil {
  static late ScreenUtil _instance;
  static const int defaultWidth = 414;
  static const int defaultHeight = 896;

  /// Tamaño del teléfono en UI Design, px
  late num uiWidthPx;
  late num uiHeightPx;

  /// allowFontScaling Especifica si las fuentes deben escalarse para respetar la configuración de accesibilidad de Tamaño de texto. El valor predeterminado es falso.
  late bool allowFontScaling;

  static late double _screenWidth;
  static late double _screenHeight;
  static late double _pixelRatio;
  static late double _statusBarHeight;
  static late double _bottomBarHeight;
  static late double _textScaleFactor;

  ScreenUtil._();

  factory ScreenUtil() {
    return _instance;
  }

  static void init(
      {num width = defaultWidth,
      num height = defaultHeight,
      bool allowFontScaling = false}) {
    _instance = ScreenUtil._();
    _instance.uiWidthPx = width;
    _instance.uiHeightPx = height;
    _instance.allowFontScaling = allowFontScaling;
    _pixelRatio = window.devicePixelRatio;
    _screenWidth = window.physicalSize.width;
    _screenHeight = window.physicalSize.height;
    _statusBarHeight = window.padding.top;
    _bottomBarHeight = window.padding.bottom;
    _textScaleFactor = window.textScaleFactor;
  }

  /// El número de píxeles de fuente para cada píxel lógico.
  static double get textScaleFactor => _textScaleFactor;

  /// El tamaño de los medios en píxeles lógicos (por ejemplo, el tamaño de la pantalla).
  static double get pixelRatio => _pixelRatio;

  /// La extensión horizontal de este tamaño.
  static double get screenWidth => _screenWidth / _pixelRatio;

  ///La extensión vertical de este tamaño. dp
  static double get screenHeight => _screenHeight / _pixelRatio;

  /// La extensión vertical de este tamaño. px
  static double get screenWidthPx => _screenWidth;

  /// La extensión vertical de este tamaño. px
  static double get screenHeightPx => _screenHeight;

  /// The offset from the top
  static double get statusBarHeight => _statusBarHeight / _pixelRatio;

  ///El desplazamiento desde arriba
  static double get statusBarHeightPx => _statusBarHeight;

  /// El desplazamiento desde abajo.
  static double get bottomBarHeight => _bottomBarHeight;

  /// La relación entre el dp real y el borrador de diseño px
  double get scaleWidth => screenWidth / uiWidthPx;

  double get scaleHeight =>
      (_screenHeight - _statusBarHeight - _bottomBarHeight) / uiHeightPx;

  double get scaleText => scaleWidth;

  /// Función de ancho
  /// Adaptado al ancho del dispositivo del UI Design.
  /// La altura también se puede adaptar de acuerdo con esto para garantizar que no se deforme,
  /// si quieres un cuadrado
  double setWidth(num width) => width * scaleWidth;

  /// Función de altura
  /// Altamente adaptable al dispositivo según UI Design
  /// Se recomienda utilizar este método para lograr un alto grado de adaptación
  /// cuando se encuentra que una pantalla en el diseño de la interfaz de usuario
  /// no coincide con el efecto de estilo actual, o si hay una diferencia en la forma.
  double setHeight(num height) => height * scaleHeight;

  /// Función tamaño de fuente
  ///@param [tamaño de fuente] interfaz de usuario en px.
  ///Método de adaptación del tamaño de fuente
  ///@param [fontSize] El tamaño de la fuente en el diseño de la interfaz de usuario, en px.
  ///@param [permitir escalado de fuentes]
  double setSp(num fontSize, {bool allowFontScalingSelf = false}) =>
      allowFontScalingSelf
          ? (allowFontScalingSelf
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _textScaleFactor))
          : (allowFontScaling
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _textScaleFactor));
}
