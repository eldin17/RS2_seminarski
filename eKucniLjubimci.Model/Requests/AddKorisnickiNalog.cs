using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddKorisnickiNalog
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Username-")]
        [MinLength(3, ErrorMessage = "Minimalna dužina korisničkog imena je 3 karaktera")]
        [MaxLength(20, ErrorMessage = "Maksimalna dužina korisničkog imena je 20 karaktera")]
        public string Username { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Password-")]
        [MinLength(5, ErrorMessage = "Minimalna dužina šifre je 5 karaktera")]
        [MaxLength(20, ErrorMessage = "Maksimalna dužina šifre je 20 karaktera")]
        public string Password { get; set; }
        [Required(ErrorMessage = "Obavezno polje -UlogaId-")]
        public int UlogaId { get; set; }
        public DateTime DatumRegistracije { get; set; }= DateTime.UtcNow;

    }
}
