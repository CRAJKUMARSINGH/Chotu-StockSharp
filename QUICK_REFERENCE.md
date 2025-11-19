# Chotu-StockSharp Maintenance - Quick Reference

## 🚀 Quick Start

```powershell
# Full maintenance (recommended)
.\maintain-chotu-stocksharp.ps1

# Or double-click
MAINTAIN.bat
```

## 📋 Common Commands

| Command | Use Case |
|---------|----------|
| `.\maintain-chotu-stocksharp.ps1` | Full pipeline with tests and push |
| `.\maintain-chotu-stocksharp.ps1 -SkipTests` | Fast build without tests |
| `.\maintain-chotu-stocksharp.ps1 -NoPush` | Local maintenance only |
| `.\maintain-chotu-stocksharp.ps1 -SkipTests -NoPush` | Quick local build |
| `.\maintain-chotu-stocksharp.ps1 -Branch develop` | Work on different branch |

## 🔧 One-Time Setup

```powershell
# Enable script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📦 What Gets Done

| Step | Action | Time |
|------|--------|------|
| 1️⃣ UPDATE | Pull from Git | ~5s |
| 2️⃣ OPTIMIZE | Clean + Restore | ~30s |
| 3️⃣ BUILD | Compile Release | ~2-5m |
| 4️⃣ VERIFY | Check artifacts | ~5s |
| 5️⃣ TEST | Run tests | ~1-3m |
| 6️⃣ CACHE | Clear caches | ~30s |
| 7️⃣ PUSH | Commit + Push | ~10s |

**Total Time**: ~5-10 minutes

## ⚡ Speed Options

```powershell
# Fastest (build only)
.\maintain-chotu-stocksharp.ps1 -SkipTests -SkipSmoke -NoPush

# Fast (skip smoke tests)
.\maintain-chotu-stocksharp.ps1 -SkipSmoke

# Normal (default)
.\maintain-chotu-stocksharp.ps1
```

## 🐛 Quick Fixes

### Script won't run
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Build fails
1. Open Visual Studio
2. Fix errors
3. Run script again

### Push fails
```powershell
git pull origin main
# Resolve conflicts
.\maintain-chotu-stocksharp.ps1
```

### Missing .NET
Download from: https://dotnet.microsoft.com/download

## 📊 Success Indicators

✅ Green checkmarks = Success  
⚠️ Yellow warnings = Non-critical issues  
❌ Red errors = Pipeline stopped  

## 🔍 Verify Installation

```powershell
dotnet --version    # Should show 8.0+
git --version       # Should show 2.x+
$PSVersionTable     # Should show 5.1+
```

## 📁 Files Created

- `maintain-chotu-stocksharp.ps1` - Main script
- `MAINTENANCE_GUIDE.md` - Full documentation
- `MAINTAIN.bat` - Double-click launcher
- `QUICK_REFERENCE.md` - This file

## 🎯 Daily Workflow

**Morning**:
```powershell
.\maintain-chotu-stocksharp.ps1
```

**During Development**:
```powershell
.\maintain-chotu-stocksharp.ps1 -SkipTests -NoPush
```

**Before Commit**:
```powershell
.\maintain-chotu-stocksharp.ps1
```

## 🔗 Links

- **StockSharp Docs**: https://doc.stocksharp.com
- **GitHub Repo**: https://github.com/CRAJKUMARSINGH/Chotu-StockSharp
- **.NET Download**: https://dotnet.microsoft.com/download

## 💡 Pro Tips

1. Run daily to catch issues early
2. Use `-NoPush` for local testing
3. Check test output for warnings
4. Keep .NET SDK updated
5. Commit before running if unsure

## 🆘 Need Help?

1. Check `MAINTENANCE_GUIDE.md` for details
2. Review error messages carefully
3. Verify prerequisites are installed
4. Check Git status: `git status`
5. Create GitHub issue with error log

---

**Last Updated**: 2025-11-18  
**Compatible With**: .NET 8.0+, Windows 10/11
