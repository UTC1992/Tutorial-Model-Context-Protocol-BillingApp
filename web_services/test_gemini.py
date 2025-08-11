import os
import base64
import httpx
import json
from dotenv import load_dotenv

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

image_path= "invoice_test.png"

def image_to_base64(path):
    with open(path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode("utf-8")

image_base64 = image_to_base64(image_path)
print("Imagen codificada con éxito.")

# Define la estructura de la herramienta
factura_tool = {
    "function_declarations": [{
        "name": "billing_save_invoice",
        "description": "Guarda los datos procesados de una factura en el sistema.",
        "parameters": {
            "type": "object",
            "properties": {
                "business_name": {"type": "string", "description": "El nombre del negocio o empresa."},
                "date": {"type": "string", "description": "La fecha en que se emitio la factura."},
                "items": {
                    "type": "array",
                    "description": "Una lista de los productos comprados.",
                    "items": {
                        "type": "object",
                        "properties": {
                            "description": {"type": "string", "description": "La descripción o nombre del producto."},
                            "quantity": {"type": "number", "description": "La cantidad del producto."},
                            "price": {"type": "number", "description": "El precio del producto."},
                            "subtotal": {"type": "number", "description": "El subtotal del producto (cantidad * precio)."}
                        }
                    }
                },
                "total": {"type": "number", "description": "El monto total de la factura."}
            }
        }
    }]
}

factura_delete_tool = {
    "function_declarations": [{
        "name": "billing_delete_invoice",
        "description": "Elimina los datos procesados de una factura en el sistema.",
        "parameters": {
            "type": "object",
            "properties": {
                "business_name": {"type": "string", "description": "El nombre del negocio o empresa."},
            }
        }
    }]
}

# Construye el cuerpo completo de la petición
request_body = {
    "contents": [{
        "parts": [
            {"text": "Analiza la siguiente imagen de una factura y extrae sus datos necesarios para eliminar la factura mediante la herramienta proporcionada, entendiendo que el nombre de la empresa es el que se encuentre bajo el logo."},
            {"inline_data": {"mime_type": "image/png", "data": image_base64}}
        ]
    }],
    "tools": [factura_tool, factura_delete_tool]
}

# Realiza la petición a Gemini
print("Realizando la petición a Gemini...")
url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={GEMINI_API_KEY}"

with httpx.Client() as client:
    response = client.post(url, json=request_body, timeout=120)

response_data = response.json()
print("Respuesta de Gemini:")
print(json.dumps(response_data, indent=2))
