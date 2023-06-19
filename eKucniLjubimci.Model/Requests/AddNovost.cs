using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddNovost
    {
        public string Naslov { get; set; }
        public string Sadrzaj { get; set; }
        public DateTime DatumPostavljanja { get; set; } = DateTime.UtcNow;

        public int ProdavacId { get; set; }
    }
}
