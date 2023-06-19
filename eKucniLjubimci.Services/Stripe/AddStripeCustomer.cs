using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Stripe
{
    public class AddStripeCustomer
    {
        public string Email { get; set; }
        public string Name { get; set; }
        public string Token { get; set; }
    }
}
