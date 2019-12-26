<?php

class KeitaiDB {
    var $path;
    
    var $header;
    
    var $spec = array();
    var $emoji = array();
    var $iemoji = array();
    var $resolusion = array();
    
    function KeitaiDB($path) {
        $this->path = $path;
    }
    
    function refSpec() {
        return array(
            'code' => '',
            'model' => 'UNKNOWN',
            'sw' => 240,
            'sh' => 320,
            'bw' => 230,
            'bh' => 320,
            'colors' => 6,
            'flashv' => 110,
            'flashs' => 100,
            'cache' => 100,
            'format1' => 600,
            'format2' => 200,
            'img' => 3,
            'mov' => 1,
            'pict' => 2
            );
    }
    
    function errorEmoji($err) {
        return array(
            'symbol' => '',
            'isjis' => 0,
            'iuni' => 0,
            'ez' => 0,
            's' => 0,
            'gaiji' => 0,
            'text' => "[Err:$err]"
            );
    }
    
    function findSpec($code) {

        if(isset($this->spec[$code]))
            return $this->spec[$code];
        

        $record = null;
        

        $fp = @fopen($this->path . '/spec.db', 'r');
        
        if($fp) {

            $header = unpack('Nsize/cversion', fread($fp, 5));
            

            while(!feof($fp)) {

                $buf = fread($fp, 2);
                if(strlen($buf) < 2)
                    break;
                $a = unpack('nlen', $buf);
                if($a['len'] < 1)
                    break;
                $id = fread($fp, $a['len']);
                

                $a = unpack('nlen', fread($fp, 2));
                
                if($id == $code) {
                    $len = $a['len'];
        

                    $a = unpack('nlen', fread($fp, 2));
                    $model = fread($fp, $a['len']);
        

                    $record = unpack('nsw/nsh/nbw/nbh/ccolors/nflashv/nflashs/ncache/nformat1/nformat2/nimg/nmov/cpict', fread($fp, $len - $a['len']));
        
                    $record['code'] = $code;
                    $record['model'] = $model;
        
                    break;
                } else {

                    fseek($fp, $a['len'], SEEK_CUR);
                }
            }
            

            fclose($fp);
        }
        

        if($record == null)
            $record = $this->refSpec();


        $this->spec[$code] = $record;
        
        return $record;
    }
    
    function findEmoji($symbol) {

        if($symbol == 'building') $symbol = 'bullding';


        if(isset($this->emoji[$symbol]))
            return $this->emoji[$symbol];
        

        $record = null;
        

        $fp = @fopen($this->path . '/emoji.db', 'r');
        
        if($fp) {

            $header = unpack('Nsize/cversion', fread($fp, 5));
            

            while(!feof($fp)) {

                $buf = fread($fp, 2);
                if(strlen($buf) < 2)
                    break;
                $a = unpack('nlen', $buf);
                if($a['len'] < 1)
                    break;
                $id = fread($fp, $a['len']);
        

                $a = unpack('nlen', fread($fp, 2));
                
                if($id == $symbol) {

                    $record = unpack('nisjis/niuni/nez/ns/ngaiji/nlen', fread($fp, 12));
                    $record['text'] = fread($fp, $record['len']);
                    unset($record['len']);
                    $record['symbol'] = $symbol;
                    break;
                } else {

                    fseek($fp, $a['len'], SEEK_CUR);
                }
            }
            

            fclose($fp);
        }
        

        if($record == null)
            $record = $this->errorEmoji($fp? "$symbol is not found": "emoji.db is not found");
        

        $this->emoji[$symbol] = $record;
        
        return $record;
    }

    function findIEmoji($icode) {

        if(isset($this->iemoji[$icode]))
            return $this->iemoji[$icode];
        

        $symbol = null;
        

        $fp = @fopen($this->path . '/iemoji.db', 'r');
        if($fp) {

            $header = unpack('Nsize/cversion', fread($fp, 5));
            

            while(!feof($fp)) {

                $buf = fread($fp, 2);
                if(strlen($buf) < 2)
                    break;
                $a = unpack('nid', $buf);
                $id = $a['id'];
                if($id == 0)
                    break;
    

                $a = unpack('nlen', fread($fp, 2));
                
                if($id == $icode) {


                    $a = unpack('nlen', fread($fp, 2));
                    $symbol = fread($fp, $a['len']);
                } else {

                    fseek($fp, $a['len'], SEEK_CUR);
                }
            }
            

            fclose($fp);
        }
        

        if($symbol == null)
            $symbol = '';
        

        $this->iemoji[$icode] = $symbol;
        
        return $symbol;
    }
    
    function getResolution() {

        if($this->resolution != null)
            return $this->resolution;
        
        $this->resolution = array();
        

        $fp = @fopen($this->path . '/resolution.db', 'r');
        if($fp) {

            $header = unpack('Nsize/cversion', fread($fp, 5));
            

            while(!feof($fp)) {

                $buf = fread($fp, 6);
                if(strlen($buf) < 6)
                    break;
                $a = unpack('nbw/nbh/ncount', $buf);
                $this->resolution[$a['bw'] . 'x' . $a['bh']] = $a['count'];
            }
            

            fclose($fp);
        }
        
        return $this->resolution;
        
    }

    function searchSpec($carrier, $format1, $format2, $include = array(), $exclude = array()) {
        $records = array();
        $models = array();
        

        $fp = @fopen($this->path . '/spec.db', 'r');
        
        if($fp) {

            $header = unpack('Nsize/cversion', fread($fp, 5));
            

            while(!feof($fp)) {

                $buf = fread($fp, 2);
                if(strlen($buf) < 2)
                    break;
                $a = unpack('nlen', $buf);
                if($a['len'] < 1)
                    break;
                $id = fread($fp, $a['len']);
                

                $buf = fread($fp, 2);
                $a = unpack('nlen', $buf);
                

                $c = substr($id, 0, 1);
                if($c == 'e') {
                    $c = 'ez';
                    $code = substr($id, 2);
                } else {
                    $code = substr($id, 1);
                }

                if($c == $carrier && !in_array($code, $exclude)) {
                    $len = $a['len'];
        

                    $a = unpack('nlen', fread($fp, 2));
                    $model = fread($fp, $a['len']);
        

                    $record = unpack('nsw/nsh/nbw/nbh/ccolors/nflashv/nflashs/ncache/nformat1/nformat2/nimg/nmov/cpict', fread($fp, $len - $a['len'] - 2));
        
                    $record['code'] = $code;
                    $record['model'] = $model;
        

                    if(!$models[$record['model']] && (($record['format1'] >= $format1 && $record['format2'] >= $format2) || in_array($code, $include))) {
                        array_push($records, $record);

                        $models[$record['model']] = true;
                    }
                } else {

                    fseek($fp, $a['len'], SEEK_CUR);
                }
            }
            

            fclose($fp);
        }
        
        return $records;
    }
    
}
?>