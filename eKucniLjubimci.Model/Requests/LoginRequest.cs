using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class LoginRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Username-")]
        [MinLength(3, ErrorMessage = "Minimalna dužina korisničkog imena je 3 karaktera")]
        [MaxLength(20, ErrorMessage = "Maksimalna dužina korisničkog imena je 20 karaktera")]
        public string Username { get; set; } = string.Empty;
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Password-")]
        [MinLength(3,ErrorMessage ="Minimalna dužina šifre je 3 karaktera")]
        [MaxLength(20,ErrorMessage ="Maksimalna dužina šifre je 20 karaktera")]
        public string Password { get; set; } = string.Empty;
    }
}

