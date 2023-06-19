using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Stripe
{
    public class AddStripePayment
    {
        public string CustomerId { get; set; }
        public string ReceiptEmail { get; set; }
        public string Description { get; set; }
        public string Currency { get; set; }
        //public decimal Amount { get; set; }
    }
}
