using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Slika
    {
        public int SlikaId { get; set; }
        public string Naziv { get; set; }
        public string Putanja { get; set; }
        public bool isDeleted { get; set; } = false;


        public int? ArtikalId { get; set; }
        public virtual Artikal? Artikal { get; set; }
        public int? ZivotinjaId { get; set; }
        public virtual Zivotinja? Zivotinja { get; set; }
    }
}
