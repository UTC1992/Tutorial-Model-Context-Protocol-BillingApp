# Invoice Control Application

An AI-powered invoice management system that uses Google Gemini AI to extract structured data from invoice images. The application consists of a Flutter mobile frontend and Python backend services.

## Features

- 📸 Camera capture and gallery selection for invoice images
- 🤖 AI-powered data extraction using Google Gemini 2.0 Flash
- 📱 Cross-platform mobile app (Android, iOS, Web)
- 🔄 Real-time invoice processing and storage
- 📊 Structured invoice data with items, totals, and business information

## Architecture

### Service Flow
1. **Flutter App** captures invoice image via camera/gallery
2. **Image Service** handles device permissions and image processing
3. **API Service** sends base64 image to Google Gemini AI
4. **Gemini AI** extracts structured invoice data using function calls
5. **MCP Server** (port 8001) receives data and forwards to main service
6. **Web Service** (port 8000) stores invoice data in memory

### Project Structure
```
├── control_invoices/          # Flutter mobile application
│   ├── lib/
│   │   └── src/
│   │       └── services/
│   │           ├── api_service.dart     # AI and backend communication
│   │           └── image_service.dart   # Camera/gallery with permissions
│   └── ...
├── web_services/              # Python backend services
│   ├── web_service.py         # Main invoice storage API (port 8000)
│   ├── save_mcp.py           # MCP proxy server (port 8001)
│   └── test_gemini.py        # AI integration testing
└── ...
```

## Technology Stack

### Frontend
- **Flutter** ^3.6.1
- **Dart SDK** ^3.6.1
- **Material Design 3**
- **HTTP** for API communication
- **Image Picker** for camera/gallery access

### Backend
- **Python** 3.13.2
- **FastAPI** 0.116.1
- **Pydantic** for data validation
- **Google Gemini 2.0 Flash** AI model

### Data Storage
- In-memory storage (development phase)

## Prerequisites

- Flutter SDK ^3.6.1
- Python 3.13.2
- Google Gemini API Key

## Setup

### 1. Environment Variables
Create `.env` files in both project roots:

**Root `.env`:**
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

**`control_invoices/.env`:**
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

**`web_services/.env`:**
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

### 2. Flutter Setup
```bash
cd control_invoices
flutter pub get
```

### 3. Python Setup
```bash
cd web_services
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Development

### Running the Application

1. **Start Python Services:**
```bash
cd web_services
source venv/bin/activate

# Terminal 1 - Main service
python web_service.py

# Terminal 2 - MCP proxy
python save_mcp.py
```

2. **Start Flutter App:**
```bash
cd control_invoices
flutter run                    # Development mode
flutter run -d chrome         # Web browser
flutter run -d android        # Android device/emulator
flutter run -d ios            # iOS device/simulator
```

### Flutter Development Commands
```bash
flutter test                   # Run tests
flutter analyze                # Static analysis
flutter clean                  # Clean build artifacts
flutter pub get                # Install dependencies

# Platform builds
flutter build apk              # Android
flutter build ios              # iOS (macOS required)
flutter build web              # Web version
```

### Python Development Commands
```bash
python test_gemini.py          # Test AI integration
```

## Network Configuration

- Flutter connects to `http://10.0.2.2:8001` (Android emulator)
- MCP proxy forwards requests to `http://localhost:8000`
- Both services require `GEMINI_API_KEY` environment variable

## Data Structure

Invoices are processed into the following structure:
```json
{
  "business_name": "String",
  "date": "String",
  "items": [
    {
      "description": "String",
      "quantity": "Number",
      "price": "Number",
      "subtotal": "Number"
    }
  ],
  "total": "Number"
}
```

## Testing

### Flutter Tests
```bash
cd control_invoices
flutter test
```

### Python Tests
```bash
cd web_services
python test_gemini.py
```

## Platform Support

- ✅ Android
- ✅ iOS (requires macOS for building)
- ✅ Web browsers
- ✅ macOS desktop
- ✅ Windows desktop
- ✅ Linux desktop

## Development Status

This project is currently in active development with in-memory storage. Future enhancements will include persistent database storage and additional features.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

## License

This project is private and not published to package repositories.