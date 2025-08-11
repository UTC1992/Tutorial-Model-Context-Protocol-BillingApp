# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an AI-powered Invoice Control Application with a Flutter mobile frontend and Python backend services. The app uses Google Gemini AI to extract structured data from invoice images through camera capture or gallery selection.

## Development Commands

### Flutter App (control_invoices/)
```bash
flutter run                    # Development mode
flutter run -d chrome         # Web browser
flutter test                   # Run tests
flutter analyze                # Static analysis
flutter pub get                # Install dependencies
flutter clean                  # Clean build artifacts

# Platform builds
flutter build apk              # Android
flutter build ios              # iOS (macOS required)
flutter build web              # Web version
```

### Python Backend (web_services/)
```bash
source venv/bin/activate       # Activate venv
python web_service.py          # Main service (port 8000)
python save_mcp.py             # MCP proxy (port 8001)
python test_gemini.py          # Test AI integration
```

## Architecture

### Service Flow
1. **Flutter App** captures invoice image via camera/gallery
2. **Image Service** handles device permissions and image processing
3. **API Service** sends base64 image to Google Gemini AI
4. **Gemini AI** extracts structured invoice data using function calls
5. **MCP Server** (port 8001) receives data and forwards to main service
6. **Web Service** (port 8000) stores invoice data in memory

### Key Components
- `/lib/src/services/api_service.dart` - AI and backend communication
- `/lib/src/services/image_service.dart` - Camera/gallery with permissions
- `web_services/web_service.py` - Main invoice storage API
- `web_services/save_mcp.py` - MCP proxy between AI and storage

### Network Configuration
- Flutter connects to `http://10.0.2.2:8001` (Android emulator)
- MCP proxy forwards to `http://localhost:8000`
- Both services require `GEMINI_API_KEY` in `.env` files

### Data Structure
Invoices are processed into:
```dart
{
  "business_name": String,
  "date": String,
  "items": [{"description": String, "quantity": Number, "price": Number, "subtotal": Number}],
  "total": Number
}
```

## Technology Stack
- **Frontend**: Flutter ^3.6.1, Material Design 3
- **Backend**: Python 3.13.2, FastAPI 0.116.1, Pydantic
- **AI**: Google Gemini 2.0 Flash model
- **Storage**: In-memory (development phase)

## Development Notes
- Both Flutter and Python require `.env` files with `GEMINI_API_KEY`
- Services must run simultaneously for full functionality
- Image processing uses base64 encoding for AI analysis
- Permission handling is critical for camera/gallery access