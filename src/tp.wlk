
class Mago {
    const nombre
    var objetosMagicos 
    var poderInnato = 0
    var resistenciaMagica 
    var categoria
    
    method categoria() = categoria
    
    method cambiarCategoria(nuevaCategoria) {
        categoria = nuevaCategoria
    } 
    method nombre() = nombre
    method objetosMagicos() = objetosMagicos
    method poderInnato() = poderInnato
    method resistenciaMagica() = resistenciaMagica

    method darPoderInnato(nuevoPoder) {
        poderInnato = (poderInnato + nuevoPoder).min(10).max(1)
    }
    method poderTotal() = objetosMagicos.sum{objetoMagico => objetoMagico.poderQueAporta(self)} * poderInnato

    method desafiaAMago(otroMago) {
        if(otroMago.categoria().puedeSerVencidoPor(otroMago, self)) {
            otroMago.categoria().consecuencias()
            categoria.energiaMagicaQueGana(otroMago)
        }
    }

}

class ObjetoMagico {
    method poderQueAporta(mago) {
    }
}

class ObjetoMagicoConPoderBase inherits ObjetoMagico {
    var poderBase
    method poderBase() = poderBase 
}

class Varita inherits ObjetoMagicoConPoderBase {
    override method poderQueAporta(mago) {
        if(mago.nombre().size().even()) {
            return poderBase * 0.5
        }
        return poderBase
    }
}

class TunicaComun inherits ObjetoMagicoConPoderBase  {
    override method poderQueAporta(mago) = mago.resistenciaMagica() * 2
}

class TunicaEpica inherits TunicaComun {
    override method poderQueAporta(mago) = super(mago) + 10
}

class Amuleto inherits ObjetoMagico {
    override method poderQueAporta(mago) = 200
}

class Ojota inherits ObjetoMagicoConPoderBase {
    override method poderQueAporta(mago) = mago.nombre().size() * 2
}

// Algunas Pruebas
const mago = new Mago(nombre = "condor", objetosMagicos = [varita], resistenciaMagica = 1, categoria = categoria)
const varita = new Varita(poderBase = 1)
const categoria = new MagoAprendiz(energiaMagica = 1)

const mago2 = new Mago(nombre= "facu", objetosMagicos = null, resistenciaMagica = 0, categoria = categoria2)
const categoria2 = new MagoAprendiz(energiaMagica = 2)

const mago3 = new Mago(nombre = "emi", objetosMagicos = [varita], resistenciaMagica = 0, categoria = categoria3)
const categoria3 = new MagoInmortal(energiaMagica = 1)

const grupo = new Gremio(integrantes = [mago, mago3])
const grupo2 = new Gremio(integrantes = [mago])

class Categoria {
    var energiaMagica 
    method energiaMagica() = energiaMagica

    
    method puedeSerVencidoPor(magoOriginal, magoAtacante) {
      
    }

    method consecuencias() {
      
    }
    method energiaMagicaQuePierde() {
        
    }

    method energiaMagicaQueGana(magoPerdedor) {
        energiaMagica = energiaMagica + magoPerdedor.categoria().energiaMagicaQuePierde()
    }

    method sumarEnergiaMagica(energiaMagicaASumar) {
        energiaMagica = energiaMagica + energiaMagicaASumar
    }
}
class MagoAprendiz inherits Categoria {
    override method puedeSerVencidoPor(magoOriginal, magoAtacante) = magoOriginal.resistenciaMagica() < magoAtacante.poderTotal()
    
    override method consecuencias() {
        energiaMagica = energiaMagica - energiaMagica/2
    }

    override method energiaMagicaQuePierde() = energiaMagica/2


}

class MagoVeterano inherits Categoria { 
    override method puedeSerVencidoPor(magoOriginal, magoAtacante) = magoAtacante.poderTotal() > (1.5 * magoOriginal.resistenciaMagica()) 

    override method consecuencias() {
        energiaMagica = energiaMagica - energiaMagica/4
    }

    override method energiaMagicaQuePierde() = energiaMagica/4 
}

class MagoInmortal inherits Categoria {
    override method puedeSerVencidoPor(magoOriginal, magoAtacante) = false

}

// Parte B

class Gremio {
    var integrantes
    
    method poderTotalDelGremio() = integrantes.sum{integrante => integrante.poderTotal()}

    method sePuedeCrearGremio() {
        if(integrantes.size() < 2 ) {
            self.error("no se puede crear gremio")
        }
    }

    method desafiarGremio(otroGremio) {
        if(otroGremio.puedeSerVencido(self)) {
            otroGremio.forEach{otroIntegrante => otroIntegrante.categoria().consecuencias()}
            var energiaTotalParaDarAlLider = otroGremio.sum{integrante => integrante.categoria().energiaMagicaQuePierde()}
            self.liderGremio().sumarEnergiaMagica(energiaTotalParaDarAlLider)
        }
    }

    method puedeSerVencido(gremioAtacante) {
        return gremioAtacante.sum{integranteAtacante => integranteAtacante.poderTotal()} > (integrantes.sum{integrante => integrante.resistenciaMagica()} + self.liderGremio().poderTotal())
    }
    
    method liderGremio() {
        return integrantes.max{integrante => integrante.poderTotal()}
    }
}

// poderTotalAtacante > 1,5 * resistenciaMagica
