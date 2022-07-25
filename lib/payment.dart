// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<String> generateOrderId(String key, String secret,int amount) async{
//   var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

//   var headers = {
//     'content-type': 'application/json',
//     'Authorization': authn,
//   };

//   var data = '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!
//   var url = Uri.parse('https://api.razorpay.com/v1/orders');
//   var res = await http.post(url, headers: headers, body: data);
//   if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
//   print('ORDER ID response => ${res.body}');

//   return json.decode(res.body)['id'].toString();
// }