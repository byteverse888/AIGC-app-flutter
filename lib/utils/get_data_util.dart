

class GetDataUtil{


  static getPostUserName(dynamic data){
    return data?["nickname"]??data?["username"]??data?["objectId"];

  }
}