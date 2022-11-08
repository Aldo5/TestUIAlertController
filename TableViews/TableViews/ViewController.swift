import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // 2.- Referencia al managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //3.- Cambiar a variable de tipo pais son datos iniciales
    private var myFood: [Comida]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        //4.- Recuperar datos
        recuperarDatos()
        
    }

    @IBAction func add(_ sender: Any) {
        //print("Añadir Datos")
        //Crear alerta
        let alert = UIAlertController(title: "Agregar comida", message: "Añade una comida nueva", preferredStyle: .alert)
        alert.addTextField()
        //Crear y configurar boton de alerta
        let botonAlert = UIAlertAction(title: "Añadir", style: .default){(action) in
            //Recuperar textField de la alerta
            let textField = alert.textFields![0]
            //Crear objeto Pais
            let nuevaComida = Comida(context:  self.context)
            nuevaComida.nombre = textField.text
            //Guardar información (Añade block do-try-catch)
            try! self.context.save()
            //Refrescar información en tableview
            self.recuperarDatos()
        }
        //Añadir boton a la alerta y mostrar la alerta
        alert.addAction(botonAlert)
        self.present(alert, animated: true, completion: nil)
    }
    func recuperarDatos(){
        do{
            //fetchRequest treae la informacion que trae de la clase entity class que tiene la entidad comida
            self.myFood = try context.fetch(Comida.fetchRequest())
            DispatchQueue.main.async {
                //Recargamos nuestra tabla
                self.tableView.reloadData()
            }
            tableView.reloadData()
        
        }
        catch{
            print("Error recuperando datos")
        }
    }
    
}




// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFood!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
            if cell == nil {
               
                cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
                
            }
        cell!.textLabel?.text = myFood![indexPath.row].nombre
            return cell!
      
            
       
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //5 print(myCountries![indexPath.row])
        //7.- Añadir funcionalidad de editar
        //Cual pais se editara?
        let comidaEditar = self.myFood![indexPath.row]
        //Crear alerta
        let alert = UIAlertController(title: "Editar Pais", message: "Editar el pais", preferredStyle: .alert)
        alert.addTextField()
        //Recuperar recuperar nombre actual de la alerta y agregarla al textField de alerta
        let textField = alert.textFields![0]
        textField.text = comidaEditar.nombre
        //Crear y configurar boton de alert
        let botonAlerta = UIAlertAction(title: "Editar", style: .default){(action) in
            //Recuperar textField de la alerta
            let textField = alert.textFields![0]
            //Editar pais actual con lo que este en el textfield
            comidaEditar.nombre = textField.text
            //Guardar información (Añade block do-try-catch)
            try! self.context.save()
            //refrescar informacion en tableView
                self.recuperarDatos()
        }
        //Añadir boton a la alerta y mostrar la alerta
        alert.addAction(botonAlerta)
        self.present(alert, animated: true, completion: nil)
    }
    //6.- Añadir funcionalidad de swipe para eliminar
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        //Crear acción de eleminar
        let accionEliminar = UIContextualAction(style: .destructive, title: "ELIMINAR"){
            (action, view, completionHandler) in
            //Cual pais se eliminara?
            let paisEliminar = self.myFood![indexPath.row]
            //Eliminar pais
            self.context.delete(paisEliminar)
            //Guardar el cambio de la información
            try! self.context.save()
            //Recargar datos
            self.recuperarDatos()
        }
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
    
}
