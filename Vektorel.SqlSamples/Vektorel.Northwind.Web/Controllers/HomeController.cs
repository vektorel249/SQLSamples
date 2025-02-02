using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using Vektorel.Northwind.Data.Managers;
using Vektorel.Northwind.Web.Models;

namespace Vektorel.Northwind.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            var nm = new NorthwindManager();
            var products = nm.GetProducts(11, 34);
            return View(products);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
