import 'dart:convert';

import 'package:http/http.dart' as http;

String apikey = "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";

class ApiServcies{ 
  static String baseUrl = "https://api.openai.com/v1/completions";

 static Map<String,String> header = {
  'content-Type': 'application/json',
  'Authorization': 'Bearer $apikey'};


static sendmessage(String? message)async{
  var response = await http.post(
    Uri.parse(baseUrl),
    headers: header,
    body: jsonEncode({
      "model": "text-davinci-003",
      "prompt": '$message',
      "temperature": 0,
      "max_tokens": 100,
      "top_p":1,
      "frequency_penalty": 0.0,
      "presence_penalty": 0.0,
      "stop": [" Human:", " AI:"]
    }),
  );

  if(response.statusCode == 200){
    var data = await jsonDecode(response.body.toString());
    var msg = data['choices'][0]['text'];
    return msg;
  }
  else{
    print("Failed to fetch data");
  }
}
}

