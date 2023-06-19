using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Stripe
{
    public class StripeCustomer
    {

        public StripeCustomer(string name, string email, string id)
        {
            Name = name;
            Email = email;
            CustomerId = id;
        }

        public string Name { get; set; }
        public string Email { get; set; }
        public string CustomerId { get; set; }
    }
}
