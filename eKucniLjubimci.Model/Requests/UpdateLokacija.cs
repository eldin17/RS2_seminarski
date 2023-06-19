using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class UpdateLokacija
    {
        public string? Drzava { get; set; }
        public string? Grad { get; set; }
        public string? Ulica { get; set; }
    }
}
