using AutoMapper;
using eKucniLjubimci.Model.DataTransferObjects;
using eKucniLjubimci.Services.Database;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using eKucniLjubimci.Services.Interfaces;

namespace eKucniLjubimci.Services
{
    public static class RecommendData
    {
        public static ITransformer model = null;
        public static MLContext mlContext = new MLContext();
        public static object isLocked = new object();
    }

    public class Recommend
    {
        public readonly DataContext _context;
        public readonly IMapper _mapper;
        
        
        public Recommend(DataContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public void TrainFunction(string modelFilePath)
        {
            lock (RecommendData.isLocked)
            {
                var dataDB = _context.Narudzbe
                .Include(x => x.Zivotinje).ThenInclude(x => x.Slike)
                .Include(x => x.Zivotinje).ThenInclude(x => x.Vrsta)
                .Include(x => x.NarudzbeArtikli).ThenInclude(x => x.Artikal).ThenInclude(x => x.Slike).ToList();

                var data = new List<ProductEntry>();

                foreach (var narudzba in dataDB)
                {
                    if (narudzba.Zivotinje.Count > 0 && narudzba.NarudzbeArtikli.Count > 0)
                    {
                        foreach (var artikal in narudzba.NarudzbeArtikli)
                        {
                            foreach (var zivotinja in narudzba.Zivotinje)
                            {
                                data.Add(new ProductEntry()
                                {
                                    ProductID = (uint)zivotinja.Vrsta.RasaId,
                                    CoPurchaseProductID = (uint)artikal.ArtikalId,
                                });
                            }
                        }
                    }
                }

                var trainData = RecommendData.mlContext.Data.LoadFromEnumerable(data);

                MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                options.MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID);
                options.MatrixRowIndexColumnName = nameof(ProductEntry.CoPurchaseProductID);
                options.LabelColumnName = "Label";
                options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                options.Alpha = 0.0051;
                options.Lambda = 0.025;

                var est = RecommendData.mlContext.Recommendation().Trainers.MatrixFactorization(options);

                RecommendData.model = est.Fit(trainData);

                RecommendData.mlContext.Model.Save(RecommendData.model, trainData.Schema, modelFilePath);
            }
        }

        public List<DtoArtikal> RecommendFunction(string modelFilePath, int id)
        {
            var _modelLoad = RecommendData.mlContext.Model.Load(modelFilePath, out DataViewSchema modelSchema);

            var sviArtikli = _context.Artikli.Where(x => x.StateMachine != "Deleted");

            var rezultat = new List<Tuple<Artikal, float>>();

            var zivotinjaFromId = _context.Zivotinje.Include(x => x.Vrsta).FirstOrDefault(x => x.ZivotinjaId == id);

            foreach (var artikal in sviArtikli)
            {
                var predictionengine = RecommendData.mlContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(_modelLoad);
                var prediction = predictionengine.Predict(
                                         new ProductEntry()
                                         {
                                             ProductID = (uint)zivotinjaFromId.Vrsta.RasaId,
                                             CoPurchaseProductID = (uint)artikal.ArtikalId
                                         });

                rezultat.Add(new Tuple<Artikal, float>(artikal, prediction.Score));
            }

            var finalRezultat = rezultat.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(2).ToList();

            return _mapper.Map<List<DtoArtikal>>(finalRezultat);
        }


        public class Copurchase_prediction
        {
            public float Score { get; set; }
        }

        public class ProductEntry
        {
            [KeyType(count: 50)]
            public uint ProductID { get; set; }

            [KeyType(count: 50)]
            public uint CoPurchaseProductID { get; set; }

            public float Label { get; set; }
        }
    }
}

