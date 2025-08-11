from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import httpx

class ExecutionRequest(BaseModel):
  capability: str
  args: dict

app = FastAPI()

WEB_SERVICE_URL = "http://localhost:8000/api/invoices"

@app.post("/execute")
async def execute_capability(request: ExecutionRequest):
  if request.capability != "billing_save_invoice":
    raise HTTPException(status_code=400, detail="Invalid capability")

  print('Orden recibida: Guardar factura, envía a web service')
  print(request.args)

  try:
    async with httpx.AsyncClient() as client:
      response = await client.post(WEB_SERVICE_URL, json=request.args)
      response.raise_for_status()
      print('Factura guardada exitosamente')
      return response.json()
  except httpx.RequestError as e:
    print(f"Error al guardar la factura: {e}")
    raise HTTPException(status_code=500, detail=str(e))
      
