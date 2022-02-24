class HelperFunctions {
  static bool urlExtension(String s) {
    return s.lastIndexOf('.svg') != -1;
  }

  static String titleClean(String s){
    return (s.lastIndexOf('-') != -1)? s.substring(0, s.lastIndexOf('-')):s;
  }
}