using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Stripe
{
    public class AddStripeCard
    {
        public string Name { get; set; }
        public string CardNumber { get; set; }
        public string ExpirationYear { get; set; }
        public string ExpirationMonth { get; set; }
        public string Cvc { get; set; }
    }
}
