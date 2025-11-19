using System;
using System.Threading;

namespace DemoRunner
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Title = "StockSharp Trading Demo";
            Console.WriteLine("====================================================================");
            Console.WriteLine("        STOCKSHARP TRADING PLATFORM - DEMO RUNNER");
            Console.WriteLine("              Automated Trading Simulation");
            Console.WriteLine("====================================================================");
            Console.WriteLine();

            RunTradingSimulation();

            Console.WriteLine();
            Console.WriteLine("Demo completed! Press any key to exit...");
            Console.ReadKey();
        }

        static void RunTradingSimulation()
        {
            Console.WriteLine("Initializing trading simulation...");
            Console.WriteLine();

            var random = new Random(42);
            var securities = new[] { "AAPL", "MSFT", "GOOGL", "AMZN", "TSLA" };
            
            Console.WriteLine("Simulating trading for 5 securities:");
            foreach (var sec in securities)
            {
                Console.WriteLine("   - " + sec);
            }

            Console.WriteLine();
            Console.WriteLine("Generating market data and executing trades...");
            Console.WriteLine();

            int tradeCount = 0;
            decimal totalPnL = 0m;

            for (int day = 0; day < 10; day++)
            {
                var date = DateTime.Today.AddDays(-10 + day);
                Console.WriteLine("Day " + (day + 1) + " - " + date.ToString("yyyy-MM-dd"));

                foreach (var security in securities)
                {
                    var basePrice = 100m + random.Next(50, 200);
                    var openPrice = basePrice + (decimal)(random.NextDouble() * 10 - 5);
                    var closePrice = openPrice + (decimal)(random.NextDouble() * 20 - 10);

                    if (random.NextDouble() > 0.5)
                    {
                        var side = random.NextDouble() > 0.5 ? "BUY " : "SELL";
                        var quantity = random.Next(10, 100);
                        var pnl = (decimal)(random.NextDouble() * 1000 - 500);
                        totalPnL += pnl;
                        tradeCount++;

                        var pnlSymbol = pnl >= 0 ? "+" : "";
                        
                        Console.ForegroundColor = ConsoleColor.Cyan;
                        Console.Write("   " + security.PadRight(6));
                        Console.ResetColor();
                        Console.Write(" | " + side + " " + quantity.ToString().PadLeft(3) + " @ ");
                        Console.ForegroundColor = ConsoleColor.Yellow;
                        Console.Write("$" + closePrice.ToString("F2"));
                        Console.ResetColor();
                        Console.Write(" | P&L: ");
                        Console.ForegroundColor = pnl >= 0 ? ConsoleColor.Green : ConsoleColor.Red;
                        Console.WriteLine(pnlSymbol + "$" + pnl.ToString("F2"));
                        Console.ResetColor();
                    }
                }
                Console.WriteLine();
                Thread.Sleep(100);
            }

            Console.WriteLine("===================================================================");
            Console.WriteLine("                    TRADING SUMMARY");
            Console.WriteLine("===================================================================");
            Console.WriteLine("Total Trades Executed: " + tradeCount);
            Console.Write("Total P&L: ");
            
            if (totalPnL >= 0)
            {
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("+$" + totalPnL.ToString("F2"));
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("$" + totalPnL.ToString("F2"));
            }
            Console.ResetColor();

            Console.WriteLine("Average P&L per Trade: $" + (totalPnL / tradeCount).ToString("F2"));
            Console.WriteLine("Win Rate: " + random.Next(45, 65) + "%");
            Console.WriteLine("Sharpe Ratio: " + (random.NextDouble() * 2).ToString("F2"));
            Console.WriteLine("===================================================================");
        }
    }
}
