using BackAPI.Data;
using BackAPI.Models;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BackAPI.Services
{
    public interface IProductService
    {
        List<Product> GetAllProducts();
    }
    public class ProductService : IProductService
    {
        private ApplicationDbContext _context { get; }
        public IConfiguration Configuration { get; }


        public ProductService(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            Configuration = configuration;
        }

        public List<Product> GetAllProducts()
        {
            return _context.Products.ToList();
        }
    }
}
