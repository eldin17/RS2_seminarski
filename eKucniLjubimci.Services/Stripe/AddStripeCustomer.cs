using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Stripe
{
    public class AddStripeCustomer
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Email-")]
        public string Email { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Name-")]
        public string Name { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Token-")]
        public string Token { get; set; }
    }
}

