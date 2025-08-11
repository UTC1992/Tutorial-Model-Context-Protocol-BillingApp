import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static const String _mcpApiUrl = 'http://10.0.2.2:8001';
  static final String _geminiApiKey = dotenv.env['GEMINI_API_KEY']!;
  static const String _geminiApiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  static Future<String> processInvoice(File imageFile) async {
    try {
      print("Paso 1: Pidiendo a Gemini que analice y decida...");
      final functionCall = await _callGemini(imageFile);

      print("Paso 2: Ejecutando la acción que Gemini indicó...");
      await _callMcpServer(
          capability: functionCall['name'], args: functionCall['args']);

      return "Factura procesada y guardada con éxito.";
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> _callGemini(File imageFile) async {
    final base64Image = base64Encode(await imageFile.readAsBytes());
    final url = Uri.parse('$_geminiApiUrl?key=$_geminiApiKey');
    final body = _buildGeminiRequestBody(base64Image);
    final response = await http
        .post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body))
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final functionCall =
          data['candidates']?[0]['content']?['parts']?[0]?['functionCall'];
      if (functionCall != null) {
        // Devolvemos la instrucción completa de Gemini.
        return functionCall;
      }
      throw Exception(
          'Análisis de IA fallido: Gemini no devolvió una instrucción de herramienta.');
    } else {
      throw Exception('Error en la API de Gemini: ${response.body}');
    }
  }

  static Map<String, dynamic> _buildGeminiRequestBody(String base64Image) {
    return {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Analiza la siguiente imagen de una factura y extrae sus datos usando la herramienta proporcionada para guardarlos."
            },
            {
              "inline_data": {"mime_type": "image/jpeg", "data": base64Image}
            }
          ]
        }
      ],
      "tools": [
        {
          "function_declarations": [
            {
              "name": "billing_save_invoice",
              "description": "Guarda los datos procesados de una factura.",
              "parameters": {
                "type": "object",
                "properties": {
                  "business_name": {
                    "type": "string",
                    "description": "Nombre del comercio"
                  },
                  "date": {
                    "type": "string",
                    "description": "Fecha de la factura"
                  },
                  "items": {
                    "type": "array",
                    "description": "Lista de items o productos comprados",
                    "items": {
                      "type": "object",
                      "properties": {
                        "description": {
                          "type": "string",
                          "description":
                              "Descripción del item o el nombre del item"
                        },
                        "subtotal": {
                          "type": "number",
                          "description": "Subtotal del item"
                        },
                        "price": {
                          "type": "number",
                          "description": "Precio del item"
                        },
                        "quantity": {
                          "type": "number",
                          "description": "Cantidad del item"
                        }
                      },
                    }
                  },
                  "total": {
                    "type": "number",
                    "description": "Total de la factura"
                  }
                },
                "required": ["business_name", "date", "items", "total"]
              }
            }
          ]
        }
      ]
    };
  }

  static Future<void> _callMcpServer(
      {required String capability, required Map<String, dynamic> args}) async {
    final url = Uri.parse('$_mcpApiUrl/execute');
    final body = {
      "capability":
          capability, // Usamos el nombre de la herramienta que Gemini nos dio.
      "args": args
    };
    final response = await http
        .post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));
    if (response.statusCode != 200)
      throw Exception('Error al guardar en el servidor: ${response.body}');
  }
}
