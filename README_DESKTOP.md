# 💻 Chotu-StockSharp - Desktop Trading Application

## Overview

**Chotu-StockSharp** is a Windows desktop trading application built on the StockSharp platform.

**Platform:** Windows (Primary), Linux/macOS (via .NET 8)  
**Type:** Desktop Application  
**Deployment:** Not suitable for web/cloud

---

## 🚀 Installation

### Windows (Recommended)

#### Option 1: Download Release
1. Go to [Releases](https://github.com/CRAJKUMARSINGH/Chotu-StockSharp/releases)
2. Download latest `Chotu-StockSharp-vX.X.X.zip`
3. Extract to desired location
4. Run `Chotu-StockSharp.exe`

#### Option 2: Build from Source
```bash
# Install .NET 8 SDK
# Download from: https://dotnet.microsoft.com/download

# Clone repository
git clone https://github.com/CRAJKUMARSINGH/Chotu-StockSharp.git
cd Chotu-StockSharp

# Build
dotnet build -c Release

# Run
dotnet run
```

### Linux/macOS (Experimental)

Requires .NET 8 Runtime:
```bash
# Install .NET 8
# https://dotnet.microsoft.com/download

# Clone and run
git clone https://github.com/CRAJKUMARSINGH/Chotu-StockSharp.git
cd Chotu-StockSharp
dotnet run
```

---

## ⚙️ Configuration

### 1. Edit `appsettings.json`

```json
{
  "StockSharp": {
    "Mode": "Demo",  // Demo, Paper, or Live
    "DataPath": "./data",
    "LogLevel": "Information"
  },
  "Connectors": {
    "Alpaca": {
      "Enabled": true,
      "ApiKey": "YOUR_API_KEY",
      "SecretKey": "YOUR_SECRET_KEY"
    }
  }
}
```

### 2. Or Use Environment Variables

Create `.env` file:
```bash
ALPACA_API_KEY=your_key_here
ALPACA_SECRET_KEY=your_secret_here
SLACK_WEBHOOK_URL=your_webhook_url
```

---

## 🎯 Features

### Trading
- ✅ Multiple broker support (Alpaca, IB, Binance)
- ✅ Real-time market data
- ✅ Order management (Market, Limit, Stop)
- ✅ Position tracking
- ✅ Portfolio management

### Analysis
- ✅ Advanced charting
- ✅ Technical indicators
- ✅ Strategy backtesting
- ✅ Performance analytics

### Automation
- ✅ Algorithmic trading
- ✅ Strategy development
- ✅ Risk management
- ✅ Notifications (Slack, Email)

---

## 📊 Supported Brokers

| Broker | Status | Features |
|--------|--------|----------|
| Alpaca | ✅ Supported | Stocks, Paper Trading |
| Interactive Brokers | ✅ Supported | Stocks, Options, Futures |
| Binance | ✅ Supported | Crypto |
| TD Ameritrade | 🔄 Planned | Stocks, Options |

---

## 🔐 Security

### Best Practices:
- ✅ Never commit API keys to git
- ✅ Use environment variables
- ✅ Enable 2FA on broker accounts
- ✅ Start with paper trading
- ✅ Use strong passwords

### Configuration:
- Store keys in `appsettings.json` (gitignored)
- Or use environment variables
- Or use Windows Credential Manager

---

## 🚫 Not Suitable For

This is a **desktop application** and is NOT suitable for:

- ❌ Web deployment (Streamlit, Vercel, etc.)
- ❌ Cloud hosting (AWS, Azure, GCP)
- ❌ Mobile devices
- ❌ Headless servers (without GUI)

### Alternatives:
- **Web Trading:** Use [Chotu-FinRL](https://github.com/CRAJKUMARSINGH/Chotu-FinRL)
- **Automated Trading:** Use [Chotu-lumibot-dev](https://github.com/CRAJKUMARSINGH/Chotu-lumibot-dev)
- **Backtesting:** Use [Chotu-backtesting](https://github.com/CRAJKUMARSINGH/Chotu-backtesting)

---

## 💡 Use Cases

### ✅ Good For:
- Local trading workstation
- Development and testing
- Advanced charting and analysis
- Custom strategy development
- VPS with remote desktop

### ❌ Not Good For:
- Web-based trading
- Mobile trading
- Serverless deployment
- Cloud-native applications

---

## 🐛 Troubleshooting

### Issue: "Application won't start"
**Solution:** Install .NET 8 Runtime from https://dotnet.microsoft.com/download

### Issue: "Broker connection failed"
**Solution:** 
1. Check API keys in `appsettings.json`
2. Verify broker is enabled
3. Check internet connection
4. Review logs in `./logs/`

### Issue: "Data not loading"
**Solution:**
1. Check data path in settings
2. Verify market is open
3. Check broker subscription

---

## 📚 Documentation

- [StockSharp Documentation](https://doc.stocksharp.com/)
- [API Reference](https://doc.stocksharp.com/api/)
- [Strategy Development](https://doc.stocksharp.com/topics/strategies.html)

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create feature branch
3. Make changes
4. Submit pull request

---

## 📜 License

MIT License - see [LICENSE](./LICENSE)

---

## 🙏 Acknowledgments

Built with [StockSharp](https://stocksharp.com/) - Professional trading platform

---

## 📞 Support

- 🐛 Issues: [GitHub Issues](https://github.com/CRAJKUMARSINGH/Chotu-StockSharp/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/CRAJKUMARSINGH/Chotu-StockSharp/discussions)
- 📧 Email: support@example.com

---

**Note:** This is a desktop application. For web-based trading, see the [Chotu Trading Suite](https://github.com/CRAJKUMARSINGH/Chotu-Trading-Suite).
