using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddNovost
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Naslov-")]
        public string Naslov { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Sadrzaj-")]
        public string Sadrzaj { get; set; }
        public DateTime DatumPostavljanja { get; set; } = DateTime.UtcNow;

        [Required(ErrorMessage = "Obavezno polje -ProdavacId-")]
        public int ProdavacId { get; set; }
    }
}
