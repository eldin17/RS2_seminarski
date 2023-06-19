using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Stripe
{
    public class AddStripeCard
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Name-")]
        public string Name { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -CardNumber-")]
        public string CardNumber { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -ExpirationYear-")]
        public string ExpirationYear { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -ExpirationMonth-")]
        public string ExpirationMonth { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Cvc-")]
        public string Cvc { get; set; }
    }
}

