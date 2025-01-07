enum GeminiModel{
  flashLatestStable
}

extension ModelName on GeminiModel{
  String get name{
    switch(this){
      case GeminiModel.flashLatestStable: return "gemini-1.5-flash";
    }
  }
}