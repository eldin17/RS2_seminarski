using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Stripe
{
    public class AddStripePayment
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -CustomerId-")]
        public string CustomerId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -ReceiptEmail-")]
        [EmailAddress(ErrorMessage = "Nije ispunjen format e-mail adrese *username@domain.com*, polje -ReceiptEmail-")]
        public string ReceiptEmail { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Description-")]
        public string Description { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Currency-")]
        public string Currency { get; set; }
    }
}

