using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services
{
    public static class rmqMail
    {
        public static void RabbitMQSend(string mailContent)
        {   
            rmqMailDetails mailDetalji = new rmqMailDetails
            {
                HostName= Environment.GetEnvironmentVariable("RabbitMQ_HostName"),
                User = Environment.GetEnvironmentVariable("RabbitMQ_UserName"),
                Password = Environment.GetEnvironmentVariable("RabbitMQ_Password"),
                Port = Environment.GetEnvironmentVariable("RabbitMQ_Port"),
                AdressFrom = Environment.GetEnvironmentVariable("RabbitMQ_MailAdressFrom"),
                AdressTo = Environment.GetEnvironmentVariable("RabbitMQ_MailAdressTo"),
                MailPassword = Environment.GetEnvironmentVariable("RabbitMQ_MailAdressPassword"),
                SmtpMail = Environment.GetEnvironmentVariable("RabbitMQ_MailSMTP"),
                EmailContent =mailContent                
            };

            var factory = new ConnectionFactory { HostName = mailDetalji.HostName, Port = int.Parse(mailDetalji.Port), UserName = mailDetalji.User, Password = mailDetalji.Password };

            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "eKucniljubimciQueue",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            string json = JsonConvert.SerializeObject(mailDetalji);
            byte[]body=Encoding.UTF8.GetBytes(json);            

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "eKucniljubimciQueue",
                                 basicProperties: null,
                                 body: body);  
        }
    }
}
